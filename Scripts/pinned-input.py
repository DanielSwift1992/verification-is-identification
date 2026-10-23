"""Read the declared pinned bytes and verify their SHA before use."""
from pathlib import Path
import hashlib,os,re,tempfile,urllib.request

def digest(data):return hashlib.sha256(data).hexdigest()

def pinned_bytes(pin, item, cache):
    address = pin['repository'] + '@' + pin['revision'] + ':' + item['path']
    target = cache / item['sha256']
    if target.exists():
        data = target.read_bytes()
    else:
        repository = pin['repository'].removeprefix('https://github.com/')
        if '/' not in repository or not re.fullmatch('[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+', repository):
            raise ValueError(address + ': unsupported input repository')
        url = 'https://raw.githubusercontent.com/' + repository + '/' + pin['revision'] + '/' + item['path']
        try:
            data = urllib.request.urlopen(url, timeout=60).read()
        except Exception as error:
            raise ValueError(address + ': unavailable pinned input: ' + str(error)) from error
        if digest(data) != item['sha256']:
            raise ValueError(address + ': input SHA-256 differs')
        cache.mkdir(parents=True, exist_ok=True)
        with tempfile.NamedTemporaryFile(dir=cache, delete=False) as stream:
            stream.write(data)
            temporary = Path(stream.name)
        os.replace(temporary, target)
    if digest(data) != item['sha256']:
        raise ValueError(address + ': input SHA-256 differs')
    return data

