const day = new Date();
const sunday = day.getTime() - 86400000 * (day.getDay()+1);
day.setTime(sunday);
const lastWeekDate = [day.toISOString().slice(0, 10)];
for(let i = 1; i < 7; i++){
	day.setTime(day.getTime() + 86400000);
	lastWeekDate.push(day.toISOString().slice(0, 10));
}


const ctx1 = document.getElementById('orderChart').getContext('2d');
 new Chart(ctx1, {
    type: 'bar',
    data: {
      labels: lastWeekDate,
      datasets: [{
        label: 'Daily Sales Count',
        data: [12, 19, 3, 5, 2, 3, 7],
        borderWidth: 2,
        backgroundColor: ['#817EE4'],
        borderColor: ['rgb(200, 200, 200)']
      }],
    },
   	options: {
	responsive: false,
      scales: {
        y: {
          beginAtZero: true
        }
      }
    }
 });

const ctx2 = document.getElementById('cstmGenderChart').getContext('2d');
new Chart(ctx2, {
    type: 'doughnut',
    data: {
	  labels: [
		'Male',
	    'Female'
	  ],
	  datasets: [{
	    label: 'Gender Count',
	    data: [5,7],
	    backgroundColor: [
	      '#B2CCFF',
	      '#FFB2D9'
	    ],
	    hoverOffset: 4
	  }]
	},
   	options: {
		responsive: false,
    }
 });
 
const ctx3 = document.getElementById('cstmAgesChart').getContext('2d');
new Chart(ctx3, {
    type: 'doughnut',
    data: {
	  labels: [
	    '10\'s',
	    '20\'s',
	    '30\'s',
	    '40\'s',
	    '50\'s',
	    '60\'s',
	  ],
	  datasets: [{
	    label: 'Age\'s Count',
	    data: [10, 50, 40, 60, 20, 10],
	    backgroundColor: [
	      '#FFA7A7',
	      '#FFC19E',
	      '#FFE08C',
	      '#B7F0B1',
	      '#B2CCFF',
	      '#D1B2FF'    
	    ],
	    hoverOffset: 4
	  }]
	},
   	options: {
		responsive: false,
    }
 });
