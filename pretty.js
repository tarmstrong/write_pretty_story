(function() {
  var filterText, formatNewParagraph, getTitle, hideTitleRequest, mainText, makeNewParagraph, onReady, onSubmit, onkeypress, requestTitle, showTitleRequest, titleTextBox;
  filterText = function(text) {
    var filteredText, paragraphs;
    filteredText = text.replace('--', '&mdash;');
    paragraphs = filteredText.split(/\n\n\n*/);
    return paragraphs;
  };
  formatNewParagraph = function(text) {
    var newParagraph, paragraph, paragraphs, _i, _len, _results;
    paragraphs = filterText(text);
    _results = [];
    for (_i = 0, _len = paragraphs.length; _i < _len; _i++) {
      paragraph = paragraphs[_i];
      newParagraph = $(document.createElement('p'));
      newParagraph.html(paragraph);
      _results.push($('#written-text').append(newParagraph));
    }
    return _results;
  };
  makeNewParagraph = function() {
    var text, textarea;
    textarea = $('#writebox textarea');
    text = textarea.val();
    formatNewParagraph(text);
    return textarea.val('');
  };
  onkeypress = function(event) {
    if (event.which === 13) {
      return $('#write-form').submit();
    }
  };
  onSubmit = function(event) {
    event.preventDefault();
    return makeNewParagraph();
  };
  mainText = {
    textArea: function() {
      return $('#writebox textarea');
    },
    appStuff: function() {
      return $('h1.story-title,#bd');
    },
    show: function() {
      this.appStuff().show();
      return this.textArea().focus();
    },
    hide: function() {
      return this.appStuff().hide();
    }
  };
  titleTextBox = function() {
    return $('#title-edit input[name="title"]');
  };
  showTitleRequest = function() {
    $('#title-edit').addClass('requesting');
    return titleTextBox().focus();
  };
  hideTitleRequest = function() {
    return $('#title-edit').removeClass('requesting');
  };
  getTitle = function() {
    var title, titleInput;
    titleInput = titleTextBox();
    title = titleInput.val();
    $('h1.story-title').html(title);
    hideTitleRequest();
    return mainText.show();
  };
  requestTitle = function() {
    mainText.hide();
    return showTitleRequest();
  };
  onReady = function() {
    $('#write-form').submit(onSubmit);
    $('#writebox textarea').keypress(onkeypress);
    requestTitle();
    return titleTextBox().keypress(function(event) {
      if (event.which === 13) {
        return getTitle();
      }
    });
  };
  $(document).ready(onReady);
}).call(this);
