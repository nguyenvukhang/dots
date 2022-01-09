import NUSModerator from 'nusmoderator'

function noBreak(text) {
  const NBSP = '\u00a0'
  return text.replace(/ /g, NBSP)
}

const now = new Date()
const data = NUSModerator.academicCalendar.getAcadWeekInfo(now)

const parts = [`AY${data.year}`]

if (data.sem) {
  parts.push(noBreak(data.sem.replace(/Semester/, 'Sem')))
}

const type = data.type === 'Instructional' ? '' : `${data.type} `
const weekNumber = data.num || ''
parts.push(noBreak(`${type}Week ${weekNumber}`))

console.log(parts.join('   ').trim())
