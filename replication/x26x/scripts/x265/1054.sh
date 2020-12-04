#!/bin/sh

numb='1055'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 10 --keyint 290 --lookahead-threads 1 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 1 --qpmax 66 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset faster --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.3,1.0,3.8,0.4,0.9,0.6,0,1,14,10,290,1,27,0,3,1,66,38,4,2000,-1:-1,dia,show,faster,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"