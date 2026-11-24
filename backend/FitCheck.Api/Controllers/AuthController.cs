using Microsoft.AspNetCore.Mvc;

namespace FitCheck.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    [HttpPost("login")]
    public IActionResult Login([FromBody] LoginRequest request)
    {
        if (request.Email == "admin@fitcheck.pl" && request.Password == "Haslo123!")
        {
            return Ok(new
            {
                message = "Zalogowano pomyślnie",
                token = "tymczasowy-token-123"
            });
        }

        return Unauthorized(new { message = "Błędny email lub hasło" });
    }
}

public record LoginRequest(string Email, string Password);