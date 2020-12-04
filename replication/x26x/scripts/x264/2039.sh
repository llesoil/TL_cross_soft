#!/bin/sh

numb='2040'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 10 --keyint 250 --lookahead-threads 3 --min-keyint 21 --qp 40 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.0,1.4,4.2,0.4,0.7,0.6,0,2,4,10,250,3,21,40,3,0,65,48,1,1000,1:1,hex,crop,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"