#!/bin/sh

numb='686'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 0.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 25 --keyint 210 --lookahead-threads 0 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.0,1.3,0.6,0.4,0.7,0.1,3,2,6,25,210,0,29,20,4,0,64,38,4,2000,-1:-1,hex,show,veryfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"