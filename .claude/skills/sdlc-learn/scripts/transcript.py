#!/usr/bin/env python3
"""Print a Claude Code session transcript as a short, numbered timeline.

  transcript.py list <project folder>      sessions in a project folder, newest first
  transcript.py show <session .jsonl> [max chars per reply]

Shows the engineer's messages in full, Claude's replies shortened, failed tool
calls, and tool counts between messages. Secrets are masked. Subagent lines
and tool output are left out.
"""
import json, os, re, sys, time
from collections import Counter

SECRET_PATTERNS = [
    re.compile(r'(?im)^.*\b(AWS_ACCESS_KEY_ID|AWS_SECRET_ACCESS_KEY|AWS_SESSION_TOKEN)\b.*$'),
    re.compile(r'\b(AKIA|ASIA)[A-Z0-9]{12,}\b'),
    re.compile(r'\b(ghp|gho|ghu|ghs|github_pat)_[A-Za-z0-9_]{20,}\b'),
    re.compile(r'(?i)\b(bearer|token|password|secret)\b(\s*[:=]\s*|\s+)\S{8,}'),
    re.compile(r'(?=[A-Za-z0-9+/=]*\d)(?=[A-Za-z0-9+/=]*[A-Z])(?=[A-Za-z0-9+/=]*[a-z])[A-Za-z0-9+/=]{32,}'),
]

def mask(text):
    for p in SECRET_PATTERNS:
        text = p.sub('[masked]', text)
    return text

def clean_user(text):
    text = re.sub(r'<system-reminder>.*?</system-reminder>', '', text, flags=re.S)
    text = re.sub(r'<local-command-(stdout|caveat)>.*?</local-command-\1>', '', text, flags=re.S)
    m = re.search(r'<command-name>(.*?)</command-name>.*?(<command-args>(.*?)</command-args>)?', text, re.S)
    if m:
        return (m.group(1) + ' ' + (m.group(3) or '')).strip()
    return text.strip()

def blocks(msg):
    c = msg.get('content') if isinstance(msg, dict) else None
    if isinstance(c, str):
        return [{'type': 'text', 'text': c}]
    return c if isinstance(c, list) else []

def first_prompt(path):
    for line in open(path, errors='replace'):
        try:
            d = json.loads(line)
        except ValueError:
            continue
        if d.get('type') == 'user' and not d.get('isSidechain'):
            for b in blocks(d.get('message')):
                if b.get('type') == 'text':
                    t = clean_user(b.get('text', ''))
                    if t:
                        return mask(t)[:100].replace('\n', ' ')
    return ''

def list_sessions(folder):
    files = sorted((os.path.join(folder, f) for f in os.listdir(folder) if f.endswith('.jsonl')),
                   key=os.path.getmtime, reverse=True)
    for f in files[:20]:
        when = time.strftime('%Y-%m-%d %H:%M', time.localtime(os.path.getmtime(f)))
        print(f'{when}  {f}\n    {first_prompt(f)}')

def show(path, limit):
    n = 0
    tools = Counter()
    def flush():
        if tools:
            print('    tools: ' + ', '.join(f'{k} x{v}' for k, v in tools.most_common()))
            tools.clear()
    for line in open(path, errors='replace'):
        try:
            d = json.loads(line)
        except ValueError:
            continue
        if d.get('isSidechain'):
            continue
        t = d.get('type')
        if t == 'user':
            for b in blocks(d.get('message')):
                if b.get('type') == 'tool_result' and b.get('is_error'):
                    c = b.get('content')
                    if isinstance(c, list):
                        c = ' '.join(x.get('text', '') for x in c if isinstance(x, dict))
                    print('    FAILED: ' + mask(str(c))[:200].replace('\n', ' '))
                elif b.get('type') == 'text':
                    text = clean_user(b.get('text', ''))
                    if text:
                        flush()
                        n += 1
                        print(f'\n[{n}] ENGINEER {d.get("timestamp", "")[:16]}\n' + mask(text))
        elif t == 'assistant':
            for b in blocks(d.get('message')):
                if b.get('type') == 'tool_use':
                    tools[b.get('name', '?')] += 1
                elif b.get('type') == 'text' and b.get('text', '').strip():
                    flush()
                    text = mask(b['text'].strip())
                    if len(text) > limit:
                        text = text[:limit] + ' [...]'
                    print('  CLAUDE: ' + text)
    flush()

if __name__ == '__main__':
    if len(sys.argv) >= 3 and sys.argv[1] == 'list':
        list_sessions(sys.argv[2])
    elif len(sys.argv) >= 3 and sys.argv[1] == 'show':
        show(sys.argv[2], int(sys.argv[3]) if len(sys.argv) > 3 else 600)
    else:
        print(__doc__)
        sys.exit(1)
