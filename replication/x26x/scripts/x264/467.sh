#!/bin/sh

numb='468'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 5 --keyint 220 --lookahead-threads 2 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.4,1.4,2.8,0.6,0.9,0.7,3,1,10,5,220,2,28,40,5,3,65,38,4,2000,-2:-2,hex,crop,fast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"