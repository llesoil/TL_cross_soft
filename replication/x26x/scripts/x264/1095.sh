#!/bin/sh

numb='1096'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 0 --keyint 250 --lookahead-threads 0 --min-keyint 29 --qp 50 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.3,1.0,2.6,0.6,0.7,0.2,0,1,14,0,250,0,29,50,3,2,69,18,4,1000,-2:-2,dia,crop,ultrafast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"