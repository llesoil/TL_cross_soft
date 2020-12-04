#!/bin/sh

numb='2961'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 1.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 20 --keyint 220 --lookahead-threads 4 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.4,1.3,1.6,0.3,0.6,0.6,2,2,10,20,220,4,30,40,3,4,67,38,1,2000,-2:-2,hex,crop,slow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"