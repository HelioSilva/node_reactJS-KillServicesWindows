const axios = require('axios');


const axiosClient = axios.create({
    
    baseURL: 'http://127.0.0.1:7000' ,
    timeout: 3000,
});


export default axiosClient;