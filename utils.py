import re
from unicodedata import normalize


def normalize_string(s):
    removed = normalize('NFKD', s).encode('ASCII', 'ignore').decode('ASCII')
    return '_'.join(
        re.sub('([A-Z][a-z]+)', r' \1',
               re.sub('([A-Z]+)', r' \1',
                      removed.replace('-', ' '))).split()).lower()
