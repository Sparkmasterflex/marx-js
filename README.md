# marx.js

[![GitHub version](https://badge.fury.io/gh/Sparkmasterflex%2Fmarx-js.svg)](http://badge.fury.io/gh/Sparkmasterflex%2Fmarx-js)

jQuery plugin for development and testing HTML forms via populating

Installation is easy. Download Marx.js, link to it with a &lt;script> tag and then initialize it in your JavaScript.

Downloads
Development Version 0.3.1
Production Version 0.3.1

<pre>
&lt;script src="/javascripts/marx.js">&lt;/script>
 
&lt;script>
  $(document).ready(function() {
    new Marx();
  });
&lt;/script>
</pre>

### Options

| Value    | Default  | Description |
|----------|----------|------------------------------------------|
| controls | standard | select controls provided by MarxJS. See below for options |
| form | null | css selector of a specific form in which to effect changes on |
| position | bottom-right | top-left, top-right, bottom-right, bottom-left |
| ipsum | 3 | default number of paragraphs for the ipsum generator |
| ipsum-max | 10 | maximum paragraphs allowed to generate |


**Control Options**

| Value    | Description |
|----------|----------------------------------------------------|
| minimum  | just the MarxJS button that fills out entire form. |
| standard | gives options for populate whole form or individual form field types. | 
| advanced | all standard options and Clear Form, Populate and Submit, Show Hidden Fields, Expand Select Boxes and Generate Ipsum.|
| toggle-advanced | gives both standard and advanced options but hides advanced till you need them |
| toggle-all | provides buttons to populate whole form, show standard controls and show advanced controls |


**Dependencies**

Marx.js has a dependency on jQuery version >= 1.10.x


## Contributing

1. Fork it ( http://github.com/Sparkmasterflex/marxjs-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
