# dockerfile-mkdocs-wkhtmltopdf

# Pre requirements

in mkdocs.yml

```yaml
extra_javascript:
  - extra.js
extra_css:
  - extra.css
```

in src/extra.js

```javascript
window.addEventListener('load', function(){window.status="ready"});
```

in src/extra.css

```css
body {
    font-family: "Noto Sans", "Noto Sans CJK JP", sans-serif;
}
```
# Usage

## serve

```bash
docker run --rm -p 8000:8000 -v $(pwd):/mnt --name mkdocs-serve netmarkjp/mkdocs-wkhtmltopdf mkdocs serve
```

## build html and pdf

```bash
docker run --rm -v $(pwd):/mnt netmarkjp/mkdocs-wkhtmltopdf
```

=> `draft-html.zip` `draft.pdf` will generate.

# in GitLab CI

example of .gitlab-ci.yml is below.

```yaml
stages:
  - release
release:
  stage: release
  tags:
    - docker
  image: netmarkjp/mkdocs-wkhtmltopdf:latest
  script:
    - ./build.sh
  artifacts:
    paths:
      - draft.pdf
      - draft-html.zip
```
