# write_pretty_story, a writing program for writers
# who don't want to edit what they write.
filterText = (text) ->
  filteredText = text
  filteredText = filteredText.replace(/&/g, '&amp;')
  filteredText = filteredText.replace(/--/g, '&mdash;')

  # Split on empty line (markdown style).
  paragraphs = filteredText.split(/\n\n\n*/)
  return paragraphs

# Given a chunk of plain text, filter it
# and print it out in the body of the page.
formatNewParagraph = (text) ->
  paragraphs = filterText(text)
  for paragraph in paragraphs
    newParagraph = $(document.createElement('p'))
    newParagraph.html(paragraph)
    $('#written-text').append(newParagraph)

wordCount = (text) ->
  if text == ""
    0
  else
    splitText = text.split(' ')
    realSplits = (word for word in splitText when word.length > 0)
    realSplits.length

# Update the word count that appears below the write-box.
syncWordCount = () ->
  display = $('#word-count')
  uncommittedText = $('textarea[name=write]').val()
  text = $('#written-text p').text()
  wc = wordCount(text) + wordCount(uncommittedText)
  display.text(wc)

# Clear the textbox and format the new paragraph
# in the body.
makeNewParagraph = () ->
  textarea = $('#writebox textarea')
  text = textarea.val()
  formatNewParagraph(text)
  textarea.val('')
  syncWordCount()

textareaKeyUp = (event) ->
  if event.which is 13
    $('#write-form').submit()
    h = $('#written-text p:last').height()
    # Autoscroll so the directions, word count
    # and uncommitted text stay in view.
    if h
      window.scrollBy(0, h + 50)
    saveStory()
  else if event.which in [32, 8]
    syncWordCount()

onSubmit = (event) ->
  event.preventDefault()
  makeNewParagraph()

mainText =
  textArea: () ->
    $('#writebox textarea')
  title: () ->
    $('h1.story-title')
  appStuff: () ->
    @title().add('#bd')
  getTitle: () ->
    @title().html()
  setTitle: (s) ->
    @title().html(s)
  show: () ->
    @appStuff().show()
    @textArea().focus()
  hide: () ->
    @appStuff().hide()
  clear: () ->
    $('#written-text').html('')

titleTextBox = () ->
  $('#title-edit input[name="title"]')

showTitleRequest = () ->
  $('#title-edit').addClass('requesting')
  titleTextBox().focus().val('')

hideTitleRequest = () ->
  $('#title-edit').removeClass('requesting')

getTitle = () ->
  titleInput = titleTextBox()
  title = titleInput.val()
  mainText.setTitle(title)

requestTitle = () ->
  mainText.hide()
  showTitleRequest()

clearStory = () ->
  localStorage.removeItem('title')
  localStorage.removeItem('paragraphs')

saveStory = () ->
  localStorage['title'] = $('h1.story-title').html()
  paragraphs = []
  $('#written-text p').each((el, i) ->
    paragraphs.push($(i).text())
  )
  localStorage['paragraphs'] = paragraphs.join("\n\n\n")

startWordCountOffset = () ->
  rawWordCount = $('#word-count').text()
  parsedWordCount = parseInt(rawWordCount)
  wordCountOffset = parsedWordCount

restoreStory = () ->
  title = localStorage['title']
  paragraphs = localStorage['paragraphs']
  mainText.setTitle(title)
  if paragraphs?
    formatNewParagraph(paragraphs)
  mainText.textArea().focus()
  syncWordCount()
  startWordCountOffset()

savedStoryExists = () ->
  localStorage? and (localStorage['paragraphs']? or localStorage['title']?)

newStory = () ->
  if Modernizr.localstorage
    clearStory()
  requestTitle()
  titleTextBox().keyup((event) ->
    if event.which is 13
      getTitle()
      hideTitleRequest()
      mainText.clear()
      mainText.show()
      if Modernizr.localstorage
        saveStory()
  )

onReady = () ->
  $('#write-form').submit(onSubmit)
  $('#writebox textarea').keyup(textareaKeyUp)
  $('#new-story').click((event) ->
    event.preventDefault()
    newStory()
  )
  if Modernizr.localstorage and savedStoryExists()
    restoreStory()
  else
    newStory()


$(document).ready(onReady)
