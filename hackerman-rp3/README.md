### Build instructions

Build the docker image first:

```sh
docker build --output=type=local,dest=/tmp/out/pack/ ./system_image/ -f ./system_image/sys-rp3.dockerfile
```
Then run `../tools/c2w`:

```sh
../tools/c2w --assets=. --to-js --target-arch=aarch64 --pack=/tmp/out/ ./dist/
```