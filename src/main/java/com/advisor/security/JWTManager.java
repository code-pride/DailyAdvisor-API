package com.advisor.security;

import com.advisor.model.entity.Role;
import com.advisor.model.entity.TokenJWT;
import com.advisor.model.entity.User;
import com.advisor.repository.TokenJWTRepository;
import com.advisor.repository.UserRepository;
import com.advisor.service.Exceptions.DataRepositoryException;
import com.advisor.service.UserService;
import io.jsonwebtoken.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.provider.OAuth2Authentication;
import org.springframework.stereotype.Component;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;

@Component
public class JWTManager {

    @Value("${jwt.cookie.name}")
    private String jwtCookieName;

    @Value("${jwt.secret}")
    private String jwtSecret;

    public UsernamePasswordAuthenticationToken authenticateJwt(HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        if(cookies == null) {
            return null;
        }
        Optional<Cookie> jwtCookie = Arrays.stream(cookies)
                .filter(cookie -> cookie.getName().equals(jwtCookieName) && cookie.getValue()!=null)
                .findFirst();
        if(jwtCookie.isPresent()) {
            Jws<Claims> jws = null;
            try {
                jws = Jwts.parser()
                        .setSigningKey(jwtSecret.getBytes())
                        .parseClaimsJws(jwtCookie.get().getValue());
            } catch (JwtException | IllegalArgumentException e) {
                return null;
            }
            String user = jws.getBody().getSubject();
            if (user != null) {
                        response.addCookie(jwtCookie.get());
                        List<GrantedAuthority> authorities = new ArrayList<>();
                        for(String role: (List<String>)jws.getBody().get("roles")) {
                            authorities.add(new SimpleGrantedAuthority(role));
                        }
                        return new UsernamePasswordAuthenticationToken(user, null, authorities);
            }
        }
        return null;
    }
}
