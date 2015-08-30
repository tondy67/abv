package abv.net.web;
/**
 * Icons
 **/
class Icons{

	public static inline var p = "/icon/";
	
	public static inline var bin = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAi5JREFUeNqMU0FoE0EUfTvZlArmFpR4L0jT3HvoKR6EQG6eC5bQeuwhIAhpYREUDz2IYKG0SEvoxbOtBIVC793oRTCQQyOlFGNNUrK72Z3x/8nOpkUQP/z9uzv/vX3vz6z1aG0NHJZllank8O/4LKVsySiCUgrfjo9h8w0H1Xu76+ubAS2OOKVERGtm3XVd7DYaT/hblN/53f2FBQhmi9OSDBqNdAaeh+HVFQaDAfr9vq7vHWeT+h4QdsZIsiMCx2ExtaBrOpWaiA5DhETc7Xbxpl5HcXb27et6vUYrzzWBnBAIBgtNg79IisWitpPJZPDRdX8loJAI4qQ5jgnarRb2trbQabfhk/QP+/vwyI4Vk3OvwYmI2ONMLDQODvB4ZQWfDg+RzWbh+z7SQsCmZBLuNTibLzcsUBMD+P56nSJLU7aN1JhATCzwkMYpjIJSuYwXjoOHpRJ+XlzAox0Z9HqYTqf1bLjX4OxwokDPgLNQKCA/NwfeVkmDe1qr6cqZIoWEsRIFZt8pEwVfm01UV1e1nebJCZ5Vq/hCB4nXtAXqNbibFlgBn+dcLvH/bnsbrzY2sLezo58tvasTC+L32ZkhSHaBIwgCbYcrK9E13mbuZQxjRevoCN1Oh4+tHQ8CndNTjEjeD3pfWV7G0uIiliqVRAH3MoaxHLco79ydn3fUtaCBqUhKRcdY0c+l6CdTXhgqn565lzGMtQ1B7/z88nY+/xL/EXI4vIwJwj8CDAAVoIrz1xox8QAAAABJRU5ErkJggg==";
	public static inline var cpp = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3gwdDjEfwqiS8QAAAslJREFUKM8FwW1oVWUAB/D/c85zzz33ZZvT7Y6pH2ILNkoIxiT6EqHRsBeoRTCE4SdByCCwiUV+Efyg0BsUWFCwhESRqEgRoqAy+5L0gghbMmPqrnPde8/O+3PO8zx/fz9BVQIy8vDDtZWB0i91x/qVSt4SDJRfuqVaD3uT4xO7do00kGv4oKElc/KX327QkCaIGG+StCS5Yczi55f3zL3x/bfXUkUWdGDyGFYDw6NbUgclbZPSBWB1xGTQsUF/89jr8ye++PDylUtFBY4VvkrSj777c/Fv9/yPdzJ3MLfVRgItpCx4X0kp/ePvX6zXnJOfXtCAbG9i78GvtFOMDrcWV5FG+aGXd/6+qp4ar0h2tvnNJyd3P39mMu2GC+8eq+sEC18u1WavXI+Yk6fO3bnw838h2XjhYlRQsbybceS50wl5/UGx59X9tOvO1RX1zARHm1gPlo7ObnlirG/ypRNWtx6fPfPPfWfitfOmf2x05uO/bq3GrWcTsQ3737k09dZPAWk37t1cY0jGZHX27JpmzM3lgtv3LbYj/rGkZl45TNVxpnZP3/h35etbuOpvn/vkm70HP7AK547M+QpJ2Od19WdHp5K4MPk9odvG2yr3zQz9enPk7UMnB7yR2Bt6c36+MJielkEnJqTr+Tt2jhWleLDRy5TRFvIx3zm78OLdA0+vrrXHH50YbqIMoqYxgdvMsrLMlEGlu5kqLfz6AB04KNEn8MiOfm3MVl/nGTaSeqFqcaIoKnA9Y0WujIVUpTWEA0kggcHy8v9l4nZ6WWh1xp4xJoqibrcbBD1XCiFEnucAJJwCNvPdRsPrJeHtMMojU+2sr7DeSrPC0qMQnldpr92u11wpIBNTrctqqEAMHT7yXjdJSoGhpiiyEEJa4SlVWqtrnhjs97M0FbQ0RepWvbxQjiNdWSVAA+NCAJoQAgBcIEvTvrr3EAQprKWwq8RlAAAAAElFTkSuQmCC";
	public static inline var dir = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAB/klEQVQ4jXWTu24TQRSGv72Y2CEEE4K4hEggpCiEJhFCpOIJqGlAiniBCJ6A8AC8AZJTIBHRQAEFXSrERQgaQLhDhCIKOBtv7N2dnTmHYh1r7cRHmmJG///Nucx4n1+u7AaVoJ4nOWHoM1atMl4/w3CYJCbvtu9fu91YV9X+eVibrNavLl+h0074+3uXaLuNabWYvrTAzMJyX+jyjB9vnzaA9TI4REFEqU1UmZ0/z+z8OeJWh58f3zPDr74wmJpDRBmOEEBFKbJSUDh+chyAzDjCwCcIPGg1jwaogjihX1ZJY50UtwcBAKJHZaCKuF4GCloiWCv4ntffj8zAWQXtWUuaNBfC0EcUvBEAH4oSnFPECq63ANLMYXLFOcU6RUR5t3F3cQCgqjgrPbMOAJLMkhqHsUquY1yeu46qfhkCgJSMSZwS/9sHoJM4cgdZLrhjFzi79PBQGb0mCiKKCmw1/2Ad5NbjdL1CEASkRpBcOHFEH/yDJootegAQxY69fYuxkGRCNxO+7TRZ3Vw9NMriJTopRtmjGytkRoliQ6USAjAFrGSGPSEaAKTd9OvO1s5iffpU/zFFUZu4Y/A0QWztQBt58Bh4VQZ4AB9e3Fvzff/RRH2Szl7M89ffHzxpfNoAtg8NHij/Rh/g5p1nayKy1G5Fm8656NaNi29GmYfjP/F6UX3c/0/PAAAAAElFTkSuQmCC";
	public static inline var favicon = "AAABAAEAEBAQAAEABAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaf8AAKL/AAD//wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMCMzMwIzMzAQIzMxAjMzEBAjMzECMzMQECMzMQIzMxAQIzMxAjMzEBAiIiECIiIQEAAAAQAAAQMRERERERETMxAjMzEBAjMzECMzMQIQIzMQIzMxAjECMxAjMzECMxAjECMzMQIzMQMQMzMxAzMzExMzMzEzMzMzMzMzMzMzMzOfPgAAHjwAAB48AAAePAAAHjwAAAAAAAAAAQAAAAcAAB4PAAAeBwAAHiMAAB4xAAAeOQAAPn0AAH7/AAD//wAA";
	public static inline var h = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQBAMAAADt3eJSAAAAElBMVEUAGAAAAAAAAISEhITGxsb///+caQWiAAAAAXRSTlMAQObYZgAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB94MHQ4yKFE4ZD0AAAA4SURBVAjXY2A2BgIDBgYG5lAgcIYxXA2gDEFBEEMJyHJEZSipwkSUiGeEwrTDGC4gAGQwCoIBAwDnCBgm6Xx89AAAAABJRU5ErkJggg==";
	public static inline var htm = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAaJJREFUeNqkUz1Lw2AQfhKDKVRoBunQH1AHVwdHcbHxB7SrawfBxc0fIKgIDoLQVWgLHU0dFFxEBy2IIA7FLm4ubZqS9CM933vbprEfInjw5Hnvcvfk7nijEBHYCoXCuaAs5hjn9ft9PioLwgT7mUwGWigna6ZSGAkyM9rtNjzPQ7fbxXOlwiLk+z6LLIk0R538kqIoATN0XUckEoEokh2k02mpL3yHD+pE9VyRQddAsVgMpuKH9qOeo1wsWudCGjJbNBrFSjKJZrMpO/qo1TAl8JsId5FIJNBqtdDr9YJ8dXL+5XtC7OBhahxN05A4fMVqNQ7DMIKRgm0L0KJVJ+xek+M4EvG9K4J5Idm2bbIbDfme84Y2FhgVu64rYRy/0dot0eknSWa/NRQOiQx2oJcb1Ck/onOyGYxT93Q8VW2BYUD4PAav3jvaQGT/DjrWaaoDsSAJWEQ7Lz7tvg+YfXGZJMIdzNwB3zYGLJdw+SU5iM3bQT6fp7DILAsXl0ql8Q7C1jZjgLk1+4c6m46r+KcFHYjlWLlcbvuvheJm3jB/CzAADjtvmF1+VKAAAAAASUVORK5CYII=";
	public static inline var hx = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3gwdDwcfSnZpswAAAeNJREFUOMuFkz1oU1EUx3/nvmcMUeOQpYK6aBfBpUTQQXTQxVncdAw4dHIphTwhgxTByS24OBYd7OakBcFa3QRF8QM/Bmkt1meEJnnn3uPQ5uXFBvJfDpx774//+bgCOMCazWYQESap1WrtuiQASZLYJCVJYkmSWPFxDOSJEMJEB41GA8AGTlzxUL1HNeB9wHs/jBrwug1vt9sMHA8c5ArqMREwg0EsaG5uHsEwhIWFW+wCZOqHTfmvS2Zj8kXA9fPLdFaeEFcOEk1dQ6qnIQi6uYp+v0/3xwZ/v8LR2cfYOECl5vn1HvzWb+TPXQ5fugLA63uXyVIDB5oGskzHO+iV9iJRDxz0N423d84QFCwTXGxIDOqqZDoKyKew/PI4paqQpdBdC1gAcRDtE1zZEXpC9eJVVBUtQHLAh281Dl14RnfNY35YpQhEFWHm9irxdB3NFC2UEY+sI2Bjdkl2ctpXLFZMxpQwfWSDL4tnifZHFP+EBej+9Lxo1Nl6s4Kq4nfGPQI4V/9Id9OIyhAdcIgTzENv3aMdj8RG9+kiGvxID/ISXKeHRIK47d9x4sZzAF7NnsKCgRniO3gNWGETckD6uUxvPSPtxLzbc4yHN+cxYKo2w8nSJ8r9PlkaeLT0YKQ//wB6nwxSVYyM2AAAAABJRU5ErkJggg==";
	public static inline var img = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAkBJREFUeNqMU01IVFEU/u59Y29GZ3RGYooiQiMnwp9pEwRBENSiVWWKEUS1dhvUtkXtpKhIXEbUKtpFrSpaVhaGYGoTNKJgWpk6zcyb927fec+Xb7RFBw7v3HvP953fp4wxuHjv9Y+q66U9D+DRFwUxgoNSCpalvz0YPJLFmpjQUYxzt1+aORpfXGOmqQVqkTpTo/I7y7cn49/NwK0XD6MEoloOLiOvusDS22vYM9qNttEO3H0HDFMdB7h0/RlO7s/g9NHusyR5hIjEfDYm7DCjnjID6CRvqmhM8dELirC0hrM0j77OLLTqGYjdedXA6zOC1WG9nniWVpnKTxRULxrpkqDWSHKwczdODY/hxI3nOJDLwPO83roMJI4mwc22IhvGiLSb1ujHF4H+Yzn0H8/BcwPCvw0MCSQDw4eUDlISEkVDWcDcm52YVQmCykjkZ3BoR4AIRYeGjDBhBRqXL6lXPl9ByUmh7CRRriZRKlxFPTxCIKnZBG4RJdhm/QtfR1DhFCo1g3INWCyOoIZ/ZqDhsqw4QTbB8VhAlNl+AaXfv1CqrPjfVp5l5JG4YRObYQhoshGuIccF5A8PwbKHMHE+i3335+FWWKrf8mQ9QXtzHz5O7MXk2JS/tussGirWgOyCjaePu+BVq+joaqf/FN+nI4ukmunbgvTWXQFBXZcUKpe3oYWLYlin+In/hjFaHJuFdGsmksFmkfmLn/hv6AGWP72fTJn15DeD69+Ww3vlsyqVl5XH/wv/UfNBjD8CDAB2EuowTBJWOwAAAABJRU5ErkJggg==";
	public static inline var mp3 = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAilBMVEX///9+l7rh7Pzc6Pvi7fx7e3vm7/ze6vzs8/3Y5vvi7PxVgMiFnb6ampp7lbx2k72Vq8iJjJPZ4e5sjsBykL+Wm6NYgsVdhMRhiMNykb+PpcSIoMBni8Gzs7Ojo6NxcXHHy9CoqKi2ub3CxMilr7ydsc2pu9Szw9pmbXiIiIh+f4BdXl+SkpJpaWm0dVniAAAAoklEQVQYlUXM2RKDIAxA0YCCuOBal1qLWGsXS///90rAmebtnmQCAPB8bFs5XjJCwM9dr+t6E4LAIddFSsUQDlmk1mZ24EUtQpiv4AQHQSohqg/nPAxDB6bVO/uDUXu7v+fKJqU0B8bYq67mtsaOogKh5O4cOzjhjxIzcR03CKOFJImw4wnhYr/jOrAwePBpO+4RMurPcToHeV6cm2ka+i5NfzubCtBK5w8rAAAAAElFTkSuQmCC";
	public static inline var mp4 = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAsSAAALEgHS3X78AAAA1klEQVQ4jaWTMYqEUBBEn+PHA/zAXM1MRBDBCwjiBcQTeAbPIGJoaKjoVcw8h6ChBrvBwsI6y+zOt5KCgn5dHbTWdd0HN/QAiKIIVdfqur7VQEgpybJMabjv+68T7uhXQJ7nDMOgDpjnmaqqSJKEpmnYtu09gBACwzDY951xHInjmLIsWZblf4CrbNsmCAKEEM/LAM7z/BHquo5lWTiOQxiGeJ6HaZoAHMfxDLiGrutSFAW+739n1yUvG7Rt+3LozwbvSKzryjRNyoBHmqZIKVF17e47fwLABFC74LC09gAAAABJRU5ErkJggg==";
	public static inline var non = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAkFBMVEUAAAB+fn7l5ejR0dX9/f3////h4eTz8vTu7vDq6ezY19zd3OD29vfOzdPNzdLV1Njp6ezc3ODy8vTV1NnY2Nzh4eP6+vv39vfv7vD29/jR0NXOzdL6+fv6+vr29vjZ19z5+fvp6e35+vru7fHz8/Th4OTq6uzV09jZ193U1Nnu7vHk5OTU1Njd3eDd3N/U09kn6rBJAAAAAXRSTlMAQObYZgAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB94MHQk0OWid9cwAAACMSURBVBjTTctXEsIwDEVRm2JkOy4ppBd6L/vfHYGXAHckfZwZMcb4N4b4fGgUPhviVwjfrNImbep6/OJZERRBX5u1gCha9O3eF0AXopyItjkB5GEtpfdeSgmY/ALsxVKIzwqA1o/wrnUYag1Q6qQS1U+XAJyL3S1+uvMxBpTTsRJgjDWmsrYyFvAfewFCjQiTjfa2WwAAAABJRU5ErkJggg==";
	public static inline var pdf = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAABoVBMVEX///+LAAHGxsYlJSWvr6+xsbHg4ODh4eHn5+fY2Nja2trq6url5eX7+/vf39/s7Ozpqqr09PTr6+vc3Nzx8fHm5ubk5OTd3d1AQECwsLDQ0NDS0tLz8/PT09PU1NS7u7vR0dHomp2rAANzc3bnRkbpSkv/BQnHx8fIyMhwcHL/GR3ljY//FBi2trbqvL5xcXOBAwX/PD7dOjnhbm/qqqvTUFHmj5DCwsL/aWu8vMKrq6uoqKz/c3Xlb2/c29v/Awf/MDPV1dWysrj/Cg71AALExMTbAALYtrnTY2eAgIXBwcHMzMzp6enb29vZ2dn/UlX/ERbjWVm8vLzXGBvNzc329vbbhIb/ICPDw8O+vsb7LTGMjI7v4uX+e37/QEPAwMDr09bfTUzuAAL/R0v/YGLi4uLy8vLiXF7/CxDqe3rLy8vbGBzFxcXw///v8PLo6Oj/AAPu7u739/eIiI3k7fDj4uO0tLSysrLDw8ve3t4eHh7pAAN9fYH6AAL19fXt7e3nR0jp7fHo29vtUVH/NTiKio3Ozs7/Njnv2tz/Jim6usAVz4NjAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3gwdCTQFR/KJSwAAAOZJREFUGNNjYGBg4CqTZJFkYWEp52CAgIiKSMsuJ+tiPhZ2IC/Wwj85zrDdISrbk5fPio2BwaYlXCdDrcClWkmTl5ePRYghpVMrwNm+NsmNsVVZvyaakyGYEQoMRLNy5DW8QIYyyXlLVZrasXFKq/vJgwXYHMUFE0v5eXzb2HXBAmJc/E1GioKFPHIcrGABDva6zEYzk9B8Lh+IAD93gqqAQINKc5gIRCBNJlCvIy+3xN2DGyIQk64tI8TBw8YVIg4RMLYVEWMX5lSQipcFC7gyFNVzi6YKc0ozybKABMwlmKGgSiIIAF2sKEgE+LRJAAAAAElFTkSuQmCC";
	public static inline var src = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAABs1BMVEX///9YWFje3t68t7GZmZn////q6uptbW3Z2dnR0dHMzMzHx8fd3d3Nzc1wcHDOzs4wMDC9vb1ycnJ0dHR2dnZ4eHh5eXl3d3eioqKDg4OJiYlra2tCQkK6urpqamqhoaF8fHxmZmZPT085OTkiIiIMDAyvr697e3vi4N6PiYS4uLhpaWmQkJB+fn5OTk44ODghISELCwvn5eL08Ozn4Nm+tq+2trZhYWFoaGhFRUUxMTEcHBwGBgaurq53dnXk4Nrz7ePu59y8rpe0tLRaWlpUVFRISEgnJycUFBQCAgKwsLB1dHHi3NLz69zs4tSysrJERERAQEA2NjYpKSkZGRkICAgAAACzs7N0cW7g18rx5tTs38q8q5BDQ0MuLi4qKioYGBgJCQm3t7dyb2re0sHu4Mrs28K8qIqtra2xsbGqqqpwbGbbzbns3MHp1rq8poVJSUk+Pj48PDw7OztWVlZ2dXR0cnBzcGxxbmhwbGWKgnfczLPp1rnn0bC8o3/k3tfg2s/e1sfd0b/bzLjcy7Lm07blzKe8oXjGwbbEvazDuKPCs5rAr5G/qoi+pX+9oHa8nnNzBIMtAAAAAXRSTlMAQObYZgAAAAFiS0dEAIgFHUgAAACpSURBVCjPY2QAAkYGKPgPZTNCyH/Mf//DBJjB5L//f/8zcjAC5b8D+VxAxrf/PIyCjCDwn4EJSH7hZfzCKMsIB/eVbqs9Z9RivK4F5n79IAMkbzOaAQVOWsBVnWN03ufMyHhXBcr/co7R/74SIxLYwuglzMh41IbxKwMPWGAlYwbjQ4Y7DM63njuABRYyFjCigEkQp9dBeD84GTshAu0MMBUNEAF+BjgAAMjNKuGLNk2YAAAAAElFTkSuQmCC";
	public static inline var txt = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQBAMAAADt3eJSAAAAD1BMVEUZAAAAAAD///+EhITGxsZZ1bN/AAAAAXRSTlMAQObYZgAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB94MHQk0HVSeER0AAAA3SURBVAjXY2BgEAABBgYGRmUgUAQyjIRAAChkpAQEKigMRUFFIXQRQTJEYAwTFxAAMhgFQYABAGcFDQfLVxtQAAAAAElFTkSuQmCC";
	public static inline var zip = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABmklEQVR4nIWSy2rbQBSGvzMz1F410KZkkSgxYiJB+xKmKA/Rt+w6qOA36LIYjW3CVC2m1IF2lSBpuojGlS9pDwyCmXP+y9EvAElyHvhPdR2fgZu6rn8O72UIICLbhxAOMUWYg36fZekGUECn4qNSiiyzb7LMvsoyqwG8r+UvIF9CIFcq3N7f/5gAI+BBReae/AXwqyxnXVQWQcbjcWGMqUTUu83m98fVaj4qy1lQAwaAdVnO2njnfS3R3mSScHr6+gNQNU2bPz7qT/Q++iV1DIejgjy/NlprAHNy8vK71mYKBAhvtwDHFgaQ59fGuWXTL7cB1s4tvg171NHJvpxbNtamVz3Bel/hswBFMdVaa6xNr5xb3rVte2Cv75MDgKKYauBMRHBueWdtav4hcrQDEIcXi9XXEAJt2zKfVw0cplUp9fTZQzwDTAgBa1PjfS3x7Nvrc7ObRMAATfScJOdhyDy01/+4BwM7SWyAdRwYMu8r7HMTBODy8iKICF3XcWy4KKaqqhatyFNiY5/3tWwBngtTVBhr2Od9LX8A3+3MXI8yBe0AAAAASUVORK5CYII=";
	public static inline var lupa = "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";
	public static inline var prefs = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QAAAAAAAD5Q7t/AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3wESCgwulTh16wAAAyxJREFUOMt1k81rHHUcxj8z+5ud3czuJtndvNlsTGpaTBCCRm2LUmyFghrwlJNCb7nlUNCLl8abF/0DPCj2ImjFF/QitlGE0jRp89IkfUnSbA15bTL7PjuzOzNfD1LQgw88tw/P4QMPIsL/9btrt+TKT9OCiMW0JBBRiGiA9ZRR/Ct7hwWZm18i99xJOnt7FhuBoJsWS9uVqp+rsXx1ljOvvMQJEV3TNAMI/zNQchpUGsKeXeXxk7WRzt4ByuUy88v3CRt1nAZoUQsggogvIApg97C4oBmxESORJtuTI55sI2WYOI5DWzqDipoU7SOShkmh5rG+W2wqaaC9t2oogJnZ2yOBipPp7iWV7qBYrrK2sIAEPl7Tp7W1lbiVRI/GuXt/HXt/m8ApwvTEPw7S3cc4LLsk2jIUShVW5m+RjCneHXsLz/dZvrdGfnuf3MAg9WiUctGmqyMDS5gK4OTQ82xcv4loEVbuLnI818PY+VPoQRM9YpJ6cZhEIsHWgU3Z8TDiCc6/fW4RBdq12w/F8Zp4okilUvw5/RsfTb6P5jqYUQ1EINLCXi3k6x9/pSfXz8bGBi0KTD1E2YcHiIrR3tFNEIZk0200mpCKxcCvQSigQ0tcx/M1am6AhOA6Drt7W6jxC69ZG3aztrj6kGR7llhLguUHm7z6wgBKWSDg+HBn9TFWMkEYhnhunfGxC4z0tcZ1IBDfRSck095KpusZHuR3eLRXoezrOKHOtu2wupYnEA2dEMtUBJ4D4CvOXYrPf/AOJTfEjFtks1lM02RuZZ3Qb6KHAfuFEs0wQnsmhedUOdrf4efvv4VPrlgaItrNO0uhbibYelIEI04620mxXCGiDHynRrXugqaT33xEts1idPgEztEOb5w9rSte/lydvjgRYxKZuZf3bswusL+7QyrdQa3uEtPhqGBjHx7hOlXOjr7JqeE+E+3LUKbOaDpzEz6TNJjK6ypskm4x6D/WxWBfDwc7W8zc+IOh488yNNhPs1qgUSvB61+YIpd9fkeH4akoIhoiGpc3Yyvrf0nBFymJyGdf/SAffvyp1ETEdkWu/nJdnl76G8YjMorxN3hkpLugkI/iAAAAAElFTkSuQmCC";
	
}// abv.net.web.Icons

