import { LightningElement } from 'lwc';

export default class Looping extends LightningElement {
    carlist =["ford","ferrari","Mercedies", "maruti","Nano"]
    ceolist = [
        {
            id : 1,
            company:"google",
            ceo : "sundar pichai"
        },
        {
            id : 2,
            company:"facebook",
            ceo : "mark zuckberg"
        },
        {
            id : 3,
            company:"amazon",
            ceo : "zeff bezos"
        }
    ]
}