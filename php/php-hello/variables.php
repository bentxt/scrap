<?php
enum Suit
{
    case Hearts;
    case Diamonds;
    case Clubs;
    case Spades;
}


function test() {
    $card = Suit::Hearts;

    $cardtext = match ($card){
        Suit::Hearts => 'fffffffuuuuuu',
        default => 'suuuuuuuuu',
    };


    echo "CCCCCCCc";
    echo $cardtext;




    $food = 'cake';
    $fruit = match ($food) {
        'apple' => 'This food is an apple',
        'bar' => 'This food is a bar',
        'cake' => 'This food is a cake',
    };

    echo $fruit;
}



test();
?>
