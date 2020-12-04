#!/bin/sh

numb='982'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 40 --keyint 250 --lookahead-threads 4 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.5,1.3,1.2,4.4,0.6,0.9,0.0,0,1,12,40,250,4,29,10,3,4,69,38,6,2000,1:1,dia,crop,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"