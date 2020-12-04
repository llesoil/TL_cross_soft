#!/bin/sh

numb='625'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 4.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 35 --keyint 300 --lookahead-threads 0 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.5,1.1,4.8,0.4,0.7,0.2,0,0,2,35,300,0,29,20,4,0,65,38,3,1000,-2:-2,dia,crop,ultrafast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"