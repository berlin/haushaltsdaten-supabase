![](https://img.shields.io/badge/Built%20with%20%E2%9D%A4%EF%B8%8F-at%20Technologiestiftung%20Berlin-blue)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

# Haushaltsdaten Supabase

<!--

Bonus:

Use all-contributors

npx all-contributors-cli check
npx all-contributors-cli add ff6347 doc

You can use it on GitHub just by commeting on PRs and issues:

```
@all-contributors please add @ff6347 for infrastructure, tests and code
```
Read more here https://allcontributors.org/


Get fancy shields at https://shields.io
 -->

Small supabase setup for haushaltsdaten 2022/2023 sprint project.

## Prerequisites

- Docker
- Supabase Account
- Deno

## Installation

To install this project, run the following command:

```bash
git clone git@github.com:berlin/haushaltsdaten-supabase.git
cd haushaltsdaten-supabase
supabase link --project-ref <YOUR PROJECT REF>
supabase db remote set <YOUR DB URL>
supabase db push
# use some kind of tool like TablePlus to populate the db with data from
# https://daten.berlin.de/datensaetze?title=doppelhaushalt&field_license_tid=All&field_publisher_tid=All&field_geo_granularity_tid=All&field_temporal_granularity_tid=All&field_geo_coverage_tid=All&state=open
# and refresh
# the materilized view
supabase functions deploy treemap-data
```

## Usage Functions

```bash
# Make a request to get the all the `Einnahmetitel` data:
curl -L -X POST 'https://zrbypchhbikbfvgqptbk.functions.supabase.co/treemap-data' -H 'Authorization: Bearer <YOUR ANON KEY HERE>'
# Make a request to get the all the `Ausgabetitel` data:
curl -L -X POST 'https://zrbypchhbikbfvgqptbk.functions.supabase.co/treemap-data?type=Ausgabetitel' -H 'Authorization: Bearer <YOUR ANON KEY HERE>'
# Make a request to get the all the `Einnahmetitel` data for the area Mitte
# The areas can be filtered with the following queries
#
# key: "hauptverwaltung" gives you: "Hauptverwaltung",
# key: "pankow" gives you: "Pankow",
# key: "reinickendorf" gives you: "Reinickendorf",
# key: "steglitz_zehlendorf" gives you: "Steglitz-Zehlendorf",
# key: "friedrichshain_kreuzberg" gives you: "Friedrichshain-Kreuzberg",
# key: "marzahn_hellersdorf" gives you: "Marzahn-Hellersdorf",
# key: "neukoelln" gives you: "Neukölln",
# key: "lichtenberg" gives you: "Lichtenberg",
# key: "treptow_koepenick" gives you: "Treptow-Köpenick",
# key: "tempelhof_schoeneberg" gives you: "Tempelhof-Schöneberg",
# key: "spandau" gives you: "Spandau",
# key: "mitte" gives you: "Mitte",
# key: "charlottenburg_wilmersdorf" gives you: "Charlottenburg-Wilmersdorf",
#
curl -L -X POST 'https://zrbypchhbikbfvgqptbk.functions.supabase.co/treemap-data?bezirk=mitte' -H 'Authorization: Bearer <YOUR ANON KEY HERE>'
```

## Contributing

### Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://fabianmoronzirfas.me/"><img src="https://avatars.githubusercontent.com/u/315106?v=4?s=128" width="128px;" alt=""/><br /><sub><b>Fabian Morón Zirfas</b></sub></a><br /><a href="https://github.com/berlin/haushaltsdaten-supabase/commits?author=ff6347" title="Documentation">📖</a> <a href="https://github.com/berlin/haushaltsdaten-supabase/commits?author=ff6347" title="Code">💻</a> <a href="#design-ff6347" title="Design">🎨</a> <a href="#infra-ff6347" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

## Content Licencing

Texts and content available as [CC BY](https://creativecommons.org/licenses/by/3.0/de/).

## Credits

<table>
  <tr>
    <td>
      Made by <a src="https://citylab-berlin.org/de/start/">
        <br />
        <br />
        <img width="200" src="https://citylab-berlin.org/wp-content/uploads/2021/05/citylab-logo.svg" />
      </a>
    </td>
    <td>
      A project by <a src="https://www.technologiestiftung-berlin.de/">
        <br />
        <br />
        <img width="150" src="https://citylab-berlin.org/wp-content/uploads/2021/05/tsb.svg" />
      </a>
    </td>
    <td>
      Supported by <a src="https://www.berlin.de/rbmskzl/">
        <br />
        <br />
        <img width="80" src="https://citylab-berlin.org/wp-content/uploads/2021/12/B_RBmin_Skzl_Logo_DE_V_PT_RGB-300x200.png" />
      </a>
    </td>
  </tr>
</table>

## Related Projects