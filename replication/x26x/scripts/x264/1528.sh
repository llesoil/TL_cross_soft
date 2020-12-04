#!/bin/sh

numb='1529'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 50 --keyint 290 --lookahead-threads 4 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 1 --qpmax 69 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.4,1.2,4.8,0.5,0.8,0.5,3,2,6,50,290,4,26,50,3,1,69,48,3,1000,-2:-2,dia,crop,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"