#!/bin/sh

numb='2877'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 30 --keyint 230 --lookahead-threads 1 --min-keyint 25 --qp 10 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.4,1.2,0.6,0.5,0.8,0.0,3,0,0,30,230,1,25,10,5,3,64,48,4,2000,-2:-2,hex,crop,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"