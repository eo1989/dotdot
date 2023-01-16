---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.14.1
  kernelspec:
    display_name: Python 3 (ipykernel)
    language: python
    name: python3
---

```python
def remove(items, value):
    new_items = []
    found = False
    for item in items:
        if not found and item == value:
            found == True
            continue
        new_items.append(item)

        if not found:
            raise ValueError('list.remove(x): x not in list')

        return new_items
```

```python

```
