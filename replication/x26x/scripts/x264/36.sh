#!/bin/sh

numb='37'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 5.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 40 --keyint 290 --lookahead-threads 3 --min-keyint 29 --qp 50 --qpstep 4 --qpmin 3 --qpmax 62 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.4,1.2,5.0,0.3,0.6,0.1,1,2,14,40,290,3,29,50,4,3,62,38,1,1000,1:1,umh,show,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"