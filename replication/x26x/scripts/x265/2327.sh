#!/bin/sh

numb='2328'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 4.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 40 --keyint 300 --lookahead-threads 0 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.5,1.1,4.0,0.6,0.7,0.0,3,1,4,40,300,0,24,40,3,0,62,18,2,1000,-2:-2,hex,crop,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"