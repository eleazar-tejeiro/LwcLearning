import {
  LightningElement
} from 'lwc';

export default class HelloQuerySelector extends LightningElement {
  isChildElementVisible = false;

  userNames = [
    "Jhon",
    "Smith",
    "Alex",
    "Doe",
    "Peter",
    "Parker"
  ];
  fetchDetailHandler() {
    const name = this.template.querySelector('h1');
    const userElements = this.template.querySelectorAll('.name');
    console.log(name.innerText);
    Array.from(userElements).forEach((userElement) => {
      console.log(userElement.innerText);
      userElement.setAttribute('title', userElement.innerText);
      userElement.setAttribute('style', 'color: red');
    });

    // LWC: Manual DOM Manipulation
    const childElement = this.template.querySelector('.child');
    if (this.isChildElementVisible) {
      childElement.innerHTML = '<h1>Child Element</h1>';
      this.isChildElementVisible = false;
    } else {
      childElement.innerHTML = '';
      this.isChildElementVisible = true;
    }
  }
}