---
layout: post
title: "Update workflow for Coding Club UC3M website"
author: hoanguc3m
date: "May 1, 2018"
categories: []
published: true
visible: false
excerpt_seperator: ""
output:
  html_document:
    mathjax:  default
---



# Home page

For a new session, two blog posts will be created. One public post that include title and the abstract for the talk and another hidden post for the full content.
Remember to check 
```
published: true
visible: false      # for the hidden post
```

After the officical announced email about the session, the register link should be changed also. Instead of changing the `index.md` file, change the link in `register.html`. See details at the homepage, line:

```
If you want to contribute a session, then please fill in this form.
```

After the talk, the picture slides of session can be added by

- Copy images to folder `public/pics`
- Change the `YAML` data file at `_data/sliders.yml`


# Calendar

When finish one session, the schedule for the next session will be updated. 

- Modify `calendar.md`.
- Update UC3M Google calendar.

# Contributors

When finish one session, the contributor for the next session will be updated. 

- Modify `contributors.md`. For example

```
contributorsY2:
  - name: 
    image_path: /public/contributor/TBA2.jpg
    link: 
    description: TBA.
```



