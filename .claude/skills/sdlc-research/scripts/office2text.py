#!/usr/bin/env python3
"""Print the text of an .xlsx, .docx or .pptx file, using only the standard library.
Usage: python3 -I office2text.py <file>"""
import re
import sys
import zipfile
import xml.etree.ElementTree as ET


def tag(el):
    return el.tag.rsplit('}', 1)[-1]


def texts(el, name='t'):
    return ''.join(t.text or '' for t in el.iter() if tag(t) == name)


def xlsx(z):
    shared = []
    if 'xl/sharedStrings.xml' in z.namelist():
        shared = [texts(si) for si in ET.fromstring(z.read('xl/sharedStrings.xml')) if tag(si) == 'si']
    wb = ET.fromstring(z.read('xl/workbook.xml'))
    names = [s.get('name') for s in wb.iter() if tag(s) == 'sheet']
    sheets = sorted((n for n in z.namelist() if re.match(r'xl/worksheets/sheet\d+\.xml$', n)),
                    key=lambda n: int(re.search(r'(\d+)', n.rsplit('/', 1)[1]).group(1)))
    for i, path in enumerate(sheets):
        print(f"## Sheet: {names[i] if i < len(names) else path}")
        for row in (r for r in ET.fromstring(z.read(path)).iter() if tag(r) == 'row'):
            cells = []
            for c in (c for c in row if tag(c) == 'c'):
                v = next((x for x in c if tag(x) == 'v'), None)
                if c.get('t') == 's' and v is not None:
                    cells.append(shared[int(v.text)])
                elif c.get('t') == 'inlineStr':
                    cells.append(texts(c))
                else:
                    cells.append(v.text if v is not None and v.text else '')
            if any(cells):
                print('\t'.join(x.replace('\n', ' ') for x in cells))


def docx(z):
    doc = ET.fromstring(z.read('word/document.xml'))
    body = next(el for el in doc if tag(el) == 'body')
    for el in body:
        if tag(el) == 'tbl':
            for tr in (r for r in el.iter() if tag(r) == 'tr'):
                print(' | '.join(texts(tc) for tc in tr if tag(tc) == 'tc'))
        elif tag(el) == 'p':
            line = texts(el)
            if line:
                print(line)


def pptx(z):
    slides = sorted((n for n in z.namelist() if re.match(r'ppt/slides/slide\d+\.xml$', n)),
                    key=lambda n: int(re.search(r'(\d+)\.xml', n).group(1)))
    for i, path in enumerate(slides, 1):
        print(f"## Slide {i}")
        for p in (p for p in ET.fromstring(z.read(path)).iter() if tag(p) == 'p'):
            line = texts(p)
            if line:
                print(line)


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    path = sys.argv[1]
    with zipfile.ZipFile(path) as z:
        kind = {'xlsx': xlsx, 'xlsm': xlsx, 'docx': docx, 'pptx': pptx}.get(path.rsplit('.', 1)[-1].lower())
        if not kind:
            sys.exit(f"not an xlsx, docx or pptx file: {path}")
        kind(z)


if __name__ == '__main__':
    main()
