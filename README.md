# TeX Live Docker Image

# Usage

```shell
// Create Working Directory
$ mkdir work && cd work
// Create Tex File
$ vim sample.tex
// Start Live Compiling
$ docker run -v $(pwd):/root/work -it nontan18/texlive latexmk --pvc sample.tex
```
## How To Add TeX Live Manager Packages

Add following line in Dockerfile.

```Dockerfile
RUN tlmgr install PACKAGE_NAME
```

and build Docker Image.

```shell
$ docker build -t texlive .
```
