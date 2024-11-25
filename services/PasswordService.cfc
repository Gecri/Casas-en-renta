component{
    function hasPassword(required string password){
        var bcrypt = wirebox.getInstance("BCrypt@BCrypt");
        return bcrypt.hashPassword(password);
    }    
    function checkPassword(required string password, required string hashedPassword) {
        var bcrypt = wirebox.getInstance("BCrypt@BCrypt");
        return bcrypt.checkPassword(password, hashedPassword);
    }
}
