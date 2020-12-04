#!/bin/sh

numb='2268'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 35 --keyint 260 --lookahead-threads 2 --min-keyint 25 --qp 0 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.5,1.3,3.6,0.5,0.7,0.5,3,1,8,35,260,2,25,0,4,2,62,38,1,1000,1:1,umh,crop,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"