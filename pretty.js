(function() {
  var clearStory, filterText, formatNewParagraph, getTitle, hideTitleRequest, mainText, makeNewParagraph, newStory, onEnter, onReady, onSubmit, requestTitle, restoreStory, saveStory, savedStoryExists, showTitleRequest, syncWordCount, titleTextBox, wordCount;
  filterText = function(text) {
    var filteredText, paragraphs;
    filteredText = text;
    filteredText = filteredText.replace(/&/g, '&amp;');
    filteredText = filteredText.replace(/--/g, '&mdash;');
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
  wordCount = function(text) {
    return text.split(' ').length;
  };
  syncWordCount = function() {
    var display, text, wc;
    display = $('#word-count');
    text = $('#written-text p').text();
    wc = wordCount(text);
    return display.text(wc);
  };
  makeNewParagraph = function() {
    var text, textarea;
    textarea = $('#writebox textarea');
    text = textarea.val();
    formatNewParagraph(text);
    textarea.val('');
    return syncWordCount();
  };
  onEnter = function(event) {
    if (event.which === 13) {
      $('#write-form').submit();
      return saveStory();
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
    title: function() {
      return $('h1.story-title');
    },
    appStuff: function() {
      return this.title().add('#bd');
    },
    getTitle: function() {
      return this.title().html();
    },
    setTitle: function(s) {
      return this.title().html(s);
    },
    show: function() {
      this.appStuff().show();
      return this.textArea().focus();
    },
    hide: function() {
      return this.appStuff().hide();
    },
    clear: function() {
      return $('#written-text').html('');
    }
  };
  titleTextBox = function() {
    return $('#title-edit input[name="title"]');
  };
  showTitleRequest = function() {
    $('#title-edit').addClass('requesting');
    return titleTextBox().focus().val('');
  };
  hideTitleRequest = function() {
    return $('#title-edit').removeClass('requesting');
  };
  getTitle = function() {
    var title, titleInput;
    titleInput = titleTextBox();
    title = titleInput.val();
    return mainText.setTitle(title);
  };
  requestTitle = function() {
    mainText.hide();
    return showTitleRequest();
  };
  clearStory = function() {
    localStorage.removeItem('title');
    return localStorage.removeItem('paragraphs');
  };
  saveStory = function() {
    var paragraphs;
    localStorage['title'] = $('h1.story-title').html();
    paragraphs = [];
    $('#written-text p').each(function(el, i) {
      return paragraphs.push($(i).text());
    });
    return localStorage['paragraphs'] = paragraphs.join("\n\n\n");
  };
  restoreStory = function() {
    var paragraphs, title;
    title = localStorage['title'];
    paragraphs = localStorage['paragraphs'];
    mainText.setTitle(title);
    if (paragraphs != null) {
      formatNewParagraph(paragraphs);
    }
    mainText.textArea().focus();
    return syncWordCount();
  };
  savedStoryExists = function() {
    return (typeof localStorage !== "undefined" && localStorage !== null) && ((localStorage['paragraphs'] != null) || (localStorage['title'] != null));
  };
  newStory = function() {
    if (Modernizr.localstorage) {
      clearStory();
    }
    requestTitle();
    return titleTextBox().keyup(function(event) {
      if (event.which === 13) {
        getTitle();
        hideTitleRequest();
        mainText.clear();
        mainText.show();
        if (Modernizr.localstorage) {
          return saveStory();
        }
      }
    });
  };
  onReady = function() {
    $('#write-form').submit(onSubmit);
    $('#writebox textarea').keyup(onEnter);
    $('#new-story').click(function(event) {
      event.preventDefault();
      return newStory();
    });
    if (Modernizr.localstorage) {
      if (savedStoryExists()) {
        return restoreStory();
      } else {
        return newStory();
      }
    } else {
      return newStory();
    }
  };
  $(document).ready(onReady);
}).call(this);
