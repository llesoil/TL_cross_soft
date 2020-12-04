#!/bin/sh

numb='1925'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 4.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 6 --crf 30 --keyint 290 --lookahead-threads 0 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,3.0,1.4,1.0,4.8,0.2,0.7,0.9,2,2,6,30,290,0,25,20,3,4,65,48,3,1000,-2:-2,dia,show,medium,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"