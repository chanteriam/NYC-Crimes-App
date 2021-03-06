let searchable = ["OFFENSES AGAINST PUBLIC ADMINI", "ASSAULT 3 & RELATED OFFENSES", "HARRASSMENT 2", "RAPE", "GRAND LARCENY", "PETIT LARCENY", "OFF. AGNST PUB ORD SENSBLTY &", "CRIMINAL TRESPASS", "CRIMINAL MISCHIEF & RELATED OF", "FELONY ASSAULT", "SEX CRIMES", "DANGEROUS DRUGS", "BURGLARY", "DANGEROUS WEAPONS", "THEFT-FRAUD", "ROBBERY", "MISCELLANEOUS PENAL LAW", "GRAND LARCENY OF MOTOR VEHICLE", "INTOXICATED & IMPAIRED DRIVING", "OTHER OFFENSES RELATED TO THEF", "POSSESSION OF STOLEN PROPERTY", "VEHICLE AND TRAFFIC LAWS", "MURDER & NON-NEGL. MANSLAUGHTER", "UNAUTHORIZED USE OF A VEHICLE", "THEFT OF SERVICES", "NYS LAWS-UNCLASSIFIED FELONY", "OFFENSES INVOLVING FRAUD", "FORGERY", "ADMINISTRATIVE CODE", "GAMBLING", "FRAUDS", "ARSON", "OFFENSES AGAINST THE PERSON", "OFFENSES RELATED TO CHILDREN", "PETIT LARCENY OF MOTOR VEHICLE", "DISORDERLY CONDUCT", "FRAUDULENT ACCOSTING", "OTHER STATE LAWS (NON PENAL LA", "BURGLAR'S TOOLS", "CHILD ABANDONMENT/NON SUPPORT", "ALCOHOLIC BEVERAGE CONTROL LAW", "KIDNAPPING & RELATED OFFENSES", "PROSTITUTION & RELATED OFFENSES", "OTHER STATE LAWS", "JOSTLING", "NEW YORK CITY HEALTH CODE", "OFFENSES AGAINST PUBLIC SAFETY", "AGRICULTURE & MRKTS LAW-UNCLASSIFIED", "LOITERING/GAMBLING (CARDS, DIC", "LOITERING/DEVIATE SEX", "HOMICIDE-NEGLIGENT,UNCLASSIFIE", "ENDAN WELFARE INCOMP", "LOITERING", "ESCAPE 3", "ANTICIPATORY OFFENSES", "DISRUPTION OF A RELIGIOUS SERV", "LOITERING FOR DRUG PURPOSES", "OTHER TRAFFIC INFRACTION", "INTOXICATED/IMPAIRED DRIVING", "HOMICIDE-NEGLIGENT-VEHICLE", "UNLAWFUL POSS. WEAP. ON SCHOOL", "ADMINISTRATIVE CODES", "UNDER THE INFLUENCE OF DRUGS", "FORTUNE TELLING", "ABORTION", "KIDNAPPING", "OTHER STATE LAWS (NON PENAL LAW)", "KIDNAPPING AND RELATED OFFENSES", "NYS LAWS-UNCLASSIFIED VIOLATION", "OFFENSES AGAINST MARRIAGE UNCL"];


const searchInput = document.getElementById('search');
const searchWrapper = document.querySelector('.wrapper');
const resultsWrapper = document.querySelector('.results');

searchInput.addEventListener('keyup', () => {
  let results = [];
  let input = searchInput.value;
  if (input.length) {
    results = searchable.filter((item) => {
      return item.toLowerCase().includes(input.toLowerCase());
    });
  }
  renderResults(results);
});

function renderResults(results) {
  if (!results.length) {
    return searchWrapper.classList.remove('show');
  }

  const content = results
    .map((item) => {
      return `<li>${item}</li>`;
    })
    .join('');

  searchWrapper.classList.add('show');
  resultsWrapper.innerHTML = `<ul>${content}</ul>`;
}