import {
  LightningElement
} from 'lwc';

export default class QuizApp extends LightningElement {
  selected = {} // for store the answers
  correctAnswers = 0; //to show the result
  isSubmitted = false; // to show the result
  myQuestions = [{
      id: "Question 1",
      question: "What is the capital of France?",
      answers: {
        a: 'London',
        b: 'Paris',
        c: 'Berlin'
      },
      correctAnswer: 'b'
    },
    {
      id: "Question 2",
      question: "What is the capital of Germany?",
      answers: {
        a: 'Berlin',
        b: 'La Paz',
        c: 'Buenos Aires'
      },
      correctAnswer: 'a'
    },
    {
      id: "Question 3",
      question: "What is the capital of England?",
      answers: {
        a: 'London',
        b: 'Bogota',
        c: 'Lima'
      },
      correctAnswer: 'a'
    }
  ]
  //handle to manage the radio buttons
  handleRadioChange(event) {
    console.log("name", event.target.name);
    console.log("value", event.target.value);
    const {
      name,
      value
    } = event.target;
    // const name = even.target.name;
    // const value = event.target.value;
    this.selected = {
      ...this.selected,
      [name]: value
    }
  }
  //handle submit for show the result
  handleSubmit(event) {
    event.preventDefault();
    let correct = this.myQuestions.filter(item => this.selected[item.id] === item.correctAnswer)
    this.correctAnswers = correct.length;
    console.log("this.correctAnswers", this.correctAnswers);
    this.isSubmitted = true;
  }

  //reset handler for reset the quiz
  handleReset() {
    this.selected = {};
    this.correctAnswers = 0;
    this.isSubmitted = false;
  }
  //used for disabling the submit button
  get allNotSelected() {
    return (Object.keys(this.selected).length !== this.myQuestions.length);
  }
  //for applying the style to our result
  get isScoredFull() {
    return `slds-text-heading_large ${this.correctAnswers === this.myQuestions.length ? 'slds-text-color_success' : 'slds-text-color_error'}`;
  }

}