# covid-19-aragon

This repository contains all the related code of the project [CurvaEnAragón](http://www.curvaenaragon.com/). A visualistation of COVID-19 or coronavirus in Aragón, using information extracted from [Aragón Open Data](https://opendata.aragon.es/datos/catalogo/dataset/publicaciones-y-anuncios-relacionados-con-el-coronavirus-en-aragon).

This project contains 3 artifacts:
- The website published in http://www.curvaenaragon.com/.
- A data processor that gets and process the original sources.
- A telegram channel to receive a daily summary https://t.me/curvaenaragon.

## The website

The website is developed using [Jekyll](https://jekyllrb.com/) and is publisherd using [Github Pages](https://pages.github.com/).

We are using some open source libraries: [SASS](https://sass-lang.com/), [chartjs](https://www.chartjs.org/) and [js-cookie](https://github.com/js-cookie/js-cookie).

The data for the website is updated daily [in this repository](../_data).

## The data processor

Right now the data processor is [a ruby script](../updater.rb) that gets the data from Aragón Open Data CSV files and gets some calculated data in new CSVs as outputs.

Also generates a daily changelog file and another one that serves as timestamp for the repo.

This script is executed in a machine and the data generated is pushed to this repo.

## The telegram channel

A [Telegram Bot](https://core.telegram.org/bots) is configured to send messages to the [CurvaEnAragón channel](https://t.me/curvaenaragon). This bot is noticed to send the message using [a workflow](../.github/workflows/telegram.yml) that is executed when the timestamp file is present in a push. Uses the Github action [externalized-telegram-notifications-action](https://github.com/danilat/externalized-telegram-notifications-action), 

## Contributors

- Design and HTML/CSS: [Vanessa Rubio](https://github.com/vanessarm/).
- Development and infrastructure: [Dani Latorre](https://github.com/danilat/).