#!/bin/sh

numb='1769'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 2.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 45 --keyint 250 --lookahead-threads 4 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.0,1.1,2.2,0.5,0.9,0.1,1,0,12,45,250,4,23,20,3,2,67,48,6,1000,1:1,umh,show,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"