#!/bin/sh

numb='421'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 0.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 20 --keyint 210 --lookahead-threads 2 --min-keyint 25 --qp 10 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.6,1.3,0.4,0.6,0.7,0.4,2,0,16,20,210,2,25,10,3,0,63,28,3,1000,1:1,umh,show,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"