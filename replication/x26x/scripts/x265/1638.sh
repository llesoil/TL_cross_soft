#!/bin/sh

numb='1639'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 4.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 30 --keyint 200 --lookahead-threads 0 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 1 --qpmax 66 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.0,1.0,1.1,4.6,0.2,0.8,0.3,3,0,14,30,200,0,28,50,4,1,66,38,6,2000,1:1,umh,show,ultrafast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"