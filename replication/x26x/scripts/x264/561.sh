#!/bin/sh

numb='562'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 0.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 5 --keyint 280 --lookahead-threads 0 --min-keyint 28 --qp 10 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.2,1.0,0.4,0.4,0.6,0.4,0,0,12,5,280,0,28,10,4,0,69,48,4,2000,1:1,hex,crop,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"