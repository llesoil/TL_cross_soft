#!/bin/sh

numb='108'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 4.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 20 --keyint 290 --lookahead-threads 3 --min-keyint 27 --qp 20 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.4,1.4,4.8,0.6,0.7,0.5,2,2,0,20,290,3,27,20,5,1,60,38,1,2000,-1:-1,dia,crop,ultrafast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"