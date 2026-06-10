package com.nguyentuanminh.test.config;

import com.nguyentuanminh.test.security.JwtAuthFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthFilter jwtAuthFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(Customizer.withDefaults())
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/api/auth/**", "/api/products/**", "/api/categories/**").permitAll() // Mở
                                                                                                               // khóa
                                                                                                               // xác
                                                                                                               // thực
                                                                                                               // và API
                                                                                                               // sản
                                                                                                               // phẩm,
                                                                                                               // danh
                                                                                                               // mục
                        .requestMatchers(org.springframework.http.HttpMethod.GET, "/api/reviews/**").permitAll() // Cho
                                                                                                                 // phép
                                                                                                                 // ai
                                                                                                                 // cũng
                                                                                                                 // xem
                                                                                                                 // được
                                                                                                                 // bình
                                                                                                                 // luận
                        .requestMatchers("/", "/*.html", "/*.css", "/*.js", "/favicon.ico", "/images/**", "/uploads/**")
                        .permitAll() // Mở khóa các file tĩnh và thư mục chứa ảnh upload
                        .anyRequest().authenticated())
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}