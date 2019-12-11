import React from 'react' ;
import styled from 'styled-components';

const Container = styled.div`
    ul{
        list-style:none
    }
  
`;

const Quadro = styled.div`
    display: flex ;
    flex-direction : row ;
    flex-wrap: wrap ;

    margin: 0 auto ;
    margin-top : 30px ;

    width:80vw;
    height:90vh ;

    background-color: rgba(10,10,10,0.2) ;
    border-radius: 10px;
    padding : 10px ;

`;

const ItemQuadro = styled.div`
    width : 150px ;
    height: 150px;
    padding: 10px ;

    margin: 5px;

    background-color: rgba(10,10,10,0.2);


`;

export {Container,Quadro,ItemQuadro}
