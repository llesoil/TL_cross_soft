#!/bin/sh

numb='1216'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 6 --crf 45 --keyint 270 --lookahead-threads 2 --min-keyint 20 --qp 20 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.6,1.4,3.0,0.2,0.9,0.0,2,2,6,45,270,2,20,20,3,0,66,48,5,2000,-2:-2,dia,show,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"