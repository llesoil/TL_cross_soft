#!/bin/sh

numb='3063'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 1.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 40 --keyint 290 --lookahead-threads 4 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.5,1.4,1.6,0.2,0.7,0.0,2,2,0,40,290,4,21,0,4,2,63,28,3,1000,-2:-2,dia,show,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"