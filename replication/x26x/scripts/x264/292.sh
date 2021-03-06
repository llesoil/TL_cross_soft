#!/bin/sh

numb='293'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 3.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 40 --keyint 200 --lookahead-threads 3 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 0 --qpmax 69 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.0,1.2,3.6,0.5,0.8,0.8,0,2,14,40,200,3,24,10,3,0,69,28,5,1000,-1:-1,umh,show,veryfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"