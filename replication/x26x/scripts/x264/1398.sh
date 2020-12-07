#!/bin/sh

numb='1399'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 20 --keyint 230 --lookahead-threads 2 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 1 --qpmax 64 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,3.0,1.6,1.2,2.0,0.2,0.8,0.3,3,1,10,20,230,2,23,20,3,1,64,38,2,2000,1:1,dia,show,slower,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"