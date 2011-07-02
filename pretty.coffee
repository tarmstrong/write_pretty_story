# write_pretty_story, a writing program for writers
# who don't want to edit what they write.

filterText = (text) ->
  filteredText = text
  filteredText = filteredText.replace(/&/g, '&amp;')
  filteredText = filteredText.replace(/--/g, '&mdash;')

  # split on empty line (markdown style)
  paragraphs = filteredText.split(/\n\n\n*/)
  return paragraphs

formatNewParagraph = (text) ->
  paragraphs = filterText(text)
  for paragraph in paragraphs
    newParagraph = $(document.createElement('p'))
    newParagraph.html(paragraph)
    $('#written-text').append(newParagraph)

makeNewParagraph = () ->
  textarea = $('#writebox textarea')
  text = textarea.val()
  formatNewParagraph(text)
  textarea.val('')

onEnter = (event) ->
  if event.which is 13
    $('#write-form').submit()
    saveStory()

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

restoreStory = () ->
  title = localStorage['title']
  paragraphs = localStorage['paragraphs']
  mainText.setTitle(title)
  if paragraphs?
    formatNewParagraph(paragraphs)
  mainText.textArea().focus()

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
  $('#writebox textarea').keyup(onEnter)
  $('#new-story').click((event) ->
    event.preventDefault()
    newStory()
  )
  if Modernizr.localstorage
    if savedStoryExists()
      restoreStory()
    else
      newStory()
  else
    newStory()


$(document).ready(onReady)
