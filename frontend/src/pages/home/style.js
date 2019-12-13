import React from 'react' ;
import styled from 'styled-components';

export const Container = styled.div`
    display :flex;
    width   :100vw;
    height  :100vh; 
`;

export const Aside = styled.aside`
    min-width: 200px;
    background-color: #eeeeee;
`;

export const Content = styled.div`
    width:100% ;
    background-color : #dfdbdc;
`;

export const Header = styled.div`
    height:30px;
    background-color : #5c7385 ;

`;

export const Quadro = styled.div`

    display : flex ;
    flex-direction : row ;
    flex-wrap: wrap ;
    padding : 10px ;

`;

export const ItemQuadro = styled.div`
    
    width : 250px ;
    height: 180px; 

    margin: 0px 5px 10px 5px;

    background-color: #ffffff;
    box-shadow: 3px 3px 3px #bbbbbb;
    border-radius : 10px;

    display:flex;
    flex-direction:column;
    
    /* justify-content: space-between; */

`;

export const TopoItem = styled.div`

    height:30%;
    background-color: #393959 ;
    border-radius : 10px 10px 0px 0px;
    box-sizing:border-box;
    overflow:visible;

    display:flex;

    justify-content:center ;
    align-items:center;

    p{
        font-size:15px ;
        color: #fff ;
        font-weight:bold ;
    }


`;
export const CorpoItem = styled.div`
    height:70%;
    background-color: #fff;
    overflow:hidden;

    border-radius : 0px 0px 10px 10px;

    display:flex;
    flex-direction:column;
    padding-left:5px;
    padding-right: 5px;

    justify-content: space-around;

    #dados{
        color : #494949 ;
        font-size : 12px;
        font-weight: 600;
    }

    #btn{
        display:flex;
        justify-content:space-around;


        p{
            cursor: pointer;
            color:#2db5c4;

            font-weight: bold ;
            font-size: 11px;
        }

        p:hover{
            background-color: #d8d8d8;
            padding : 2px;
        }

        .aprovado{
            color: #1e8404;
        }
        .bloqueado{
            color: #e90a0a;
        }
    }

    p{
        font-size:12px;
    }

`;