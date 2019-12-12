import React from 'react' ;
import styled from 'styled-components';

export const Container = styled.div`
    display:flex;
    width:100vw;
    height:100vh; 
`;

export const Aside = styled.aside`
    min-width: 200px;
    background-color: #eeeeee;
`;

export const Content = styled.div`
    width:100% ;
    background-color: #dfdbdc;
`;

export const Header = styled.div`
    height:30px;
    background-color:#5c7385 ;

`;

export const Quadro = styled.div`

    display : flex ;
    flex-direction : row ;
    flex-wrap: wrap ;
    padding : 10px ;

`;

export const ItemQuadro = styled.div`
    
    width : 180px ;
    height: 200px;

    padding: 10px ;

    margin: 10px;

    background-color: #FFFFFF;
    box-shadow: 3px 3px 3px #bbbbbb;

    display:flex;
    flex-direction:column;
    
    justify-content: space-between;

    /* Telefone */
    h4{
        margin:0;
        padding:0;
        margin-bottom:5px;
        color:#adadad;
        font-family:'robot';
        font-size:12px;
    }
    /* Razao Social */
    h2{
        font-weight:bold;
        font-size: 20px;
        color: #585858;
    }
    p{
        color: #f8503d;
        font-size: 10px;
        font-weight: bold;
        font-family: 'arial';
    }

`;


